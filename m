Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37629 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab1DMTfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 15:35:25 -0400
Received: by fxm17 with SMTP id 17so686185fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2011 12:35:24 -0700 (PDT)
Message-ID: <4DA5FAF9.3090309@gmail.com>
Date: Wed, 13 Apr 2011 21:35:21 +0200
From: Till Kamppeter <till.kamppeter@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Google Summer of Code 2011 - Wireless application
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

no one of the wireless people has asked for mentorship at the Google 
Summer of Code yet, so no one can see the 3 wireless applications. I 
copy them below, but note that they do not look great. If you are 
interested, register as mentor for the Linux Foundation on 
http://www.google-melange.com/, and as soon as you get the approval from 
me, score and comment ASAP.

If you are not interested at all, please tell me ASAP so that I can 
simply reject the applications on your behalf.

    Till

---------

802.11n Adhoc support and stability improvements to Linux Wireless
------------------------------------------------------------------

Rudolf Meijering

Email: skaapgif@gmail.com

Mentor: No mentor assigned

Short description: Improve 802.11n adhoc support / stability and 
throughput specifically for better mesh networking. This would help 
projects/communities such as freifunk, batman-adv and the Village Telco.


Name: Rudolf Meijering



University: University of Stellenbosch / Electronic Engineering with 
Computer Science



Short bio / overview of your background:

Started using Linux when I was 13 years old. Used Red Hat Linux, 
OpenSUSE, Ubuntu and Gentoo as desktop distributions. I took computer 
science as subject at school and had extra programming classes after 
school. Started studying Electronic engineering with Computer Science as 
major in 2006. I did numerous holiday jobs including Linux kernel boot 
time optimization, boot loader optimization and driver initialization 
time optimizations.



Email: skaapgif@gmail.com

IRC: irc.freenode.net sKAApGIF



What platform do you use to code?: Ubuntu 11.04, x86_64 (Intel i7), 
OpeWRT trunk, TP-link wr1043nd, wr743nd and Village Telco 'Mesh Potato'.

Coding Languages / Skills:

     Experienced with:

         C       3 Semester courses, Wrote basic functionality OS for 
x86 qemu

         C++     1 Semester course with weekly tutorials / projects

         Java    3 Semester courses including advanced data structures, 
algorithms

         Python  Wrote Web Shop concept prototype in Django for holiday work

         Touched and played around with Perl / Bash scripts, mostly for 
init and configuration scripts



Required experience:

     C - very comfortable with C especially low level programming such 
as drivers.

     802.11 basics - I started the Stellenbosch Wireless User Group. 
Setup my own wireless mesh network. Flashed more routers with OpenWRT 
than I can rememeber and I have a strong background in the mathematics 
of wireless communication (rf propagation, multipath, antenna 
directivity / gain).



I have built the snapshot ath9k drivers numerous times for 802.11n 
stability and throughput improvements.



You and Us



I'm actively involved in the Village Telco (Wireless Mesh Networking 
Infrastructure), providing mailing list support, participating in 
workshops and testing hardware / drivers.



Why have you chosen your development idea and what do you expect from 
your implementation?

My current mesh network contains several ar71xx based nodes. Making 
improvements to ath9k or linux wireless in general will therefore 
provide direct benefit to myself. In addition from my participation in 
the Village Telco I have become aware that the Village Telco could 
greatly benefit from 802.11n, but unfortunately driver stability and 
performance is currently keeping them from transitioning to better hardware.



What do you want to achieve?

Improve 802.11n ad-hoc support and throughput in ath9k and ath9k-htc. 
Re-introduce VAP support for multiple ad-hoc/managed vap's per radio.



What makes you suited to carry the project?

I have a thorough understanding of 802.11n basics, kernel modules and 
drivers and excellent low level C coding skills.



How much time do you plan to invest in the project before, during and 
after the Summer of Code? Before GSoC I will have about 1hour per day, 
full time during GSoC, and about 2 hours per day after GSoC.



Determine current state of ad-hoc in ath9k and ath9k_htc

Investigate required work to re-introduce VAP support

Re-introduce VAP support and do necessary work to make future code 
maintanance easier

Work on support for ad-hoc in ath9k_htc

Improve ad-hoc throughput performance

Perform stability testing / bug fixing / maintenance

Average score:
1/10 out of 1 users, total: 1

1 private comments

Hin-Tak Leung April 9, 2011, 1:07 a.m.

While the credential looks inpressive, the goal is not clear.

----------

802.11 - Wireless LAN (kernel & userspace)
------------------------------------------

pandorra

Email: pandorrarv@gmail.com

Mentor: No mentor assigned

Short description: write wireless patches in Linux(Ubuntu, Debian)

Status: pending

Name: Pasha Sydoryshyn

University: Lviv Polytechnic National University

Short bio: I'm a specialist in IT technology

IRC nick: pandorra

What platform do you use to code? Hardware specifications and operating 
system: OS Ubuntu 10.04, Windows XP sp3

Good grasp C/C++. Experience - 3 year.

Average score:
0/10 out of 1 users, total: 0

1 private comments

Hin-Tak Leung April 8, 2011, 8:38 p.m.

A bit poor.

----------

Improve wireless roaming
------------------------

meet88

Email: harmeet.2303@gmail.com

Mentor: No mentor assigned

Short description: In this project, I intend to improve user experience 
of roaming in WLAN. This can be achieved by making handover schemes 
seamless. Also, I intend to provide support which can reduce signalling 
overhead over the IPv6-network.

Status: pending

     * Name :- Harmeet Singh

     * University:- Indian Institute of Technology Kanpur
     * Short bio:- I am forth year student in computer science and 
engineering department. I have interest in computer networks. At 
present, I am studying IEEE 802.11 and other issues which one face in 
WLANs. I have done courses in networks and have hands-on experience with 
WSN. I posses strong coding skills and knowledge of 802.11 to pursue 
this project.
     * IRC nick and group:- meet88 freenode

     * Coding Skills:- C, C++, Java, Python

In your application let us know


     * Did you ever code in C or C++/Perl/python/..., yes/no? what is 
your experience?
     Answer: Yes, I have done coding in C and python. I have done many 
projects in C. I implemented network sniffer in C which can sniff 
traffic in ethernet network. I have also developed applications for 
android based mobile phones.
     * If you apply for a project on our ideas list, have you experience 
in the areas listed under "Desired knowledge"?


Your Project

     * What do you want to achieve?
     Answer: I want to improve experience of roaming in wireless 
networks, At present, handover is one of the bottleneck to provide good 
QoS in real time application. Also, mobility introduce long delays and 
signalling overhead in present mobile-IPv6. I want to implement 
techniques which can achieve seamless handover and reduce the delay and 
overhead of mobility.
     I have chosen this odea because I have studied extensively about 
various techniques which can be applied. Also, I have been involved 
working in projects related to computer networks. I think, I can apply 
my knowledge and skill for the better expeerience of others in community.
     I have done experience of developing application. I understand that 
designing the problem solution takes time and better solution can be 
provided if we know what exactly we are looking for. The coursework and 
projects that I have done in my studies make me confident that I can 
carry this project and complete it successfully.
     I intend to devote 25-35 hours/week to this project.
I intend to begin work on may-4
At first, I would like to design problem solution. For that, I need to 
specify requirements of application and decide which technology/language 
etc to use to develop it. I would like to start implementing it as early 
as possible. I intend to deliver first version by end of may-fisrt week 
of june. Then by july first week, I intend to cover major part of 
project and start testing by july end. I want to deliver project by 
mid-august.

Avarage score:
0/10 out of 0 users, total: 0

----------
