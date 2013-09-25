Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sns.it ([192.167.206.31]:22190 "EHLO sns.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751249Ab3IYHL5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 03:11:57 -0400
Received: from [217.202.70.218] (account m.vietri@sns.it)
  by sns.it (CommuniGate Pro WEBUSER 5.4.9)
  with HTTP id 129659891 for linux-wireless@vger.kernel.org; Wed, 25 Sep 2013 08:51:09 +0200
From: "Mario Vietri" <m.vietri@sns.it>
Subject: 
To: linux-wireless@vger.kernel.org
Date: Wed, 25 Sep 2013 08:51:09 +0200
Message-ID: <web-129660237@sns.it> (sfid-20130925_091200_831625_74CAE21B)
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8; format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Sirs,

I have a pc with an Intel Card, Intel Corporation Centrino 
Advanced-N 6235 [8086:088e] (rev 24), driven by iwlwifi. I 
have installed the backports version of iwlwifi.

The card and the driver work flawlessly. I am having troubles, 
though, when I try two build two   virtual interfaces on this 
card, one in Station mode and the other in AP mode.

The output of iw list states, among other things, that:

Supported interface modes: 
                                                            │
                  * IBSS
                  * managed
                  * AP
                  * AP/VLAN
                  * monitor
                  * P2P-client
                  * P2P-GO
         software interface modes (can always be added):
                  * AP/VLAN
                  * monitor
         valid interface combinations:
                  * #{ managed } <= 1, #{ AP, P2P-GO } <= 1,
                    total <= 2, #channels <= 1, STA/AP BI must 
match
                  * #{ managed } <= 2, #{ P2P-client } <= 1,
                    total <= 2, #channels <= 1


I have interpreted this to mean that I can put my card into AP 
mode (I did, it works). The "valid interface combinations" 
appeared to state (if I read them right) that I can have at 
most one vif in station mode, 1 vif in AP mode, for a grand 
total of two, provided that they are on the same channel, and 
provided that


  STA/AP BI must match


What does this mean? I have been unable to find this on 
Google, and several posts at moderately knowledgeable BBs like 
SuperUser, StackOverflow and the like have provided no 
enlightenment.

Since clients connecting to my AP are so far unable to obtain
an IP address from my network, I am wondering whether this
requirement, whose meaning I completely ignore, is the source
of the problem.

  

Do you think you can help me out on this one?


Cheers,


Mario
Prof. Mario Vietri
Scuola Normale Superiore
56100 Pisa
Italia

Tel.: 39-050-509096
FAX:  39-050-509045
Cell: 39-333-7877992
