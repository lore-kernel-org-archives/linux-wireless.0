Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56101.mail.re3.yahoo.com ([216.252.110.195]:27111 "HELO
	web56101.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751850AbZKDErS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 23:47:18 -0500
Message-ID: <676274.50697.qm@web56101.mail.re3.yahoo.com>
Date: Tue, 3 Nov 2009 20:47:23 -0800 (PST)
From: vikram g <vikramadb@yahoo.com>
Subject: Help regarding wireless driver programming
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
          I am a graduate student who wants to work on a
project which uses one wireless card to connect to more than one
network using time multiplexing at the same time. Yes, it is very
similar to virtualwifi by microsoft. But I want to accomplish it on
linux.
About me :
                  Bads :
1) I am not very good at systems programming.
2) The only things I have done are some kinds of socket programming and have some knowledge of packet sniffing techniques related to networks.
3) I am not very knowledgeable about wireless device drivers or device driver layer for wireless networks.
etc.

          Can you please help me finding me a place to start. I have gone through the only material on linuxwireless.org (about mac80211 and cfg80211 slides), but as I said I am not very
knowledgeable I did not understand much of it. Also I went very quickly
skimmed through the source code for ath9k and iwlwifi slides. But it
seems that the functionality I am looking for is not present in those
layers. All the things I am looking for are 1) To know where the kernel
connects to a wireless network by its SSID. 2) where it receives packets from the network layer that
is IP protocol (by where I mean where in the source code is it
implemented) so that I can capture them before it is passed to the 2nd
layer of the OSI model.

 
        I do not know actually if this project is going to be
successfull given my less knowledge. Also it would be great if I get
any feedback from any of you.


I really really appreciate the
time of all you guys. I know I am a beginner and I do not know if this
mailing list is not for beginners. Please forgive me if this mailing
list is not for guys like me and let me know about the same.


Thanks,
Vikram Gade
Masters student in CS, University of New Mexico, Albuquerque, New Mexico

PS: Please forgive me for any incorrect or bad English that may have crept in


      
