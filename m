Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:63677 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbZDCTJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 15:09:02 -0400
Received: by fg-out-1718.google.com with SMTP id e12so542581fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 12:08:59 -0700 (PDT)
Message-ID: <49D65EC7.70105@gmail.com> (sfid-20090403_210907_708348_2484404B)
Date: Fri, 03 Apr 2009 21:08:55 +0200
From: Till Kamppeter <till.kamppeter@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Jussi Kukkonen <jku@linux.intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Dan Williams <dcbw@redhat.com>
Subject: Google Summer of Code 2009: Another wireless application
References: <68f4d6130903241108j590d49adj10446169f7c3c06b@mail.gmail.com> 	<43e72e890903241256l39f5b1f9i49ce2b7a6e8099c3@mail.gmail.com> 	<49CD0FCF.3060706@gmail.com> <43e72e890903271126p7a302460lffdd5cd8d6ebe807@mail.gmail.com>
In-Reply-To: <43e72e890903271126p7a302460lffdd5cd8d6ebe807@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we got another application on wireless. See below. Who has not done so
yet, do not forget to apply as mentor for the LF at
http://socghop.appspot.com/.

    Till

--------------------

Title:  	Proposal for AP support to Network Manager
Student: 	Rathin Radhakrishnan
Mentor: 	No mentor assigned
Possible Mentors: 	None
Abstract:
mac80211 is the Linux API used to write wireless drivers. As of 2.6.29 
the Linux kernel gets AP support for mac80211 drivers.Using hostapd is a 
method to enable this support. All new mac80211 based drivers that 
implement AP functionality are supported with hostapd's nl80211 drive.A 
GUI based control configuration utility is required for AP support.
Content:

Name : Rathin.Radhakrishnan

B.tech in Computer Science and Engineering in Model Engineering 
College(Cochin University of Science and Technology)

I am doing my 6th semester in B.Tech .  I have been interested computer 
science related stuffs from school days ,but from the day i got to use 
Open Source applications i have delved more into what exactly Computer 
Science is all about . I take this opportunity with The Linux Foundation 
in GSOC as a learning curve in my career.

irc-nick : nap_ster

I own a DELL INSPIRON 1525 which has a Intel Core to duo T5450 .And the 
operating system i use is GNU/Linux(UBUNTU).

I have done my school-level project that was a software that managed an 
automatic car-parking system .It was coded in C++.

My mini-project in the college  was an automated script that identified 
an idle system  and brought it down if found to be idle .it was scripted 
down in Perl

I would like to apply for your idea to Add AP support for Netwrok 
Manager . I have been using C as a language for my various lab sessions 
in my college. I have completed a set of Lab as well as theory subjects 
on C .I have alwas been interested in Computer Networks and wirless 
networks being an area of develpoment currently has always attracted me 
.Although i have not been much a part of any development in this section 
i have read certain papers on it . Linux Kernels have always interested 
me . I have always tried recompiling some of the updates on kernels even 
before they were integrated into my OS(Ubuntu).But as of now i dont have 
much of Kernel Development experience.Given a choice to choose 
scripting language i would choose Perl and Python cause i have been 
fascinated by the power of both of them .

This is my first hand experinece with The Linux Foundation as well as 
the GSOC.

My implementation would be like: A system when in AP mode can set itself 
  have a hostapd ( Host Access Point Daemon ) . The Host Access Point 
daemon (hostapd) manages user-space 802.11 functions such as 
authentication, encryption, initializing network interface, beacon 
intervals, extended authorization protocol (EAP) keys, etc.

The things i would like to achieve from this project would include 
successfull integration of access point mode into network manager .Also 
since there are no current GUI for the AP mode so that would be also a 
part of achievements. Not to forget about the whole knowledge that i get 
access to while working with such a coveted organisation like The Linux 
Foundation.

I have choosen the idea to provide AP support for Network manager cause 
i have always wondered about this. I have always looked in through the 
various modes of operation available for a wireless card in GNU/Linux 
System and had always question about why there was no access point mode.

I had actually planned on doing a project on wireless routing .The 
actual project was to provide a  network connection to a system who got 
access to the network through a system that was connected in the 
network. This idea made me search all kinds of papers and books on what 
to do .In the end  had to give it up when i found that the modes of 
operation was just  managed and ad-hoc mode . And i feel that i am 
suited for this project because of the fact i have a natural attraction 
to this subject as stated above. I feel that when provided with an 
opportunity i should be able to overcome  each hurdle that i encounter 
through the course of this project . And i have the confidence to take 
the responsiblity too .

As we have got summer hols from May1 to June 30 time shouldnt be a 
problem for me . I could easily dedicated 40 hrs/week if not more .

I would subdivide my task into various levels. And depending on the 
number of levels i should divide the time for each subtasks as well . 
Currently it includes the integration of AP mode into network manager as 
well as the GUI for the AP mode.

