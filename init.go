package main

import (
	"fmt"
	"log"

	"path/filepath"
	"github.com/fatih/color"
	"gopkg.in/AlecAivazis/survey.v1"
)

var initConfig = []*survey.Question{
	{
		Name: "env",
		Prompt: &survey.Select{
			Message: "Which environment do you want the application to be initialized in?",
			Options: []string{"Development", "Production"},
			Default: "Development",
		},
	},
}

func main() {
	color.Blue("Application Initialization Tool v0.1")

	//Start Setup
	answers := struct {
		Environments string `survey:"env"`
	}{}

	err := survey.Ask(initConfig, &answers)
	if err != nil {
		fmt.Println(err.Error())
		return
	}


	color.Yellow("Start initialization ...")
	//Default "dev"
	env := "dev"
	if answers.Environments == "Production"{
		env = "prod"
	}
	files, err := filepath.Glob("./environments/"+env+"/*")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(files)
	color.Yellow("... initialization completed")
}
