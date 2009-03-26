Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:36454 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbZCZPbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 11:31:22 -0400
Message-ID: <49CB9F99.2030505@lwfinger.net> (sfid-20090326_163125_014213_2D6FE3C0)
Date: Thu, 26 Mar 2009 10:30:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "RuXu W." <wrxzzj@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 make kernel 2.6.29 crashed, help!
References: <737c90be0903240006q2066c53bl1ce50eadd45e893b@mail.gmail.com>	 <49C8F476.5070500@lwfinger.net>	 <737c90be0903241851kc948f39q2cd9502a35c4c3ac@mail.gmail.com>	 <49C99FF8.6090509@lwfinger.net>	 <737c90be0903242026j3906bcbdp3da287713eb2962@mail.gmail.com>	 <49C9AE04.5090003@lwfinger.net> <737c90be0903242117k7ec7e2a9rdfb6df7d10c849c5@mail.gmail.com>
In-Reply-To: <737c90be0903242117k7ec7e2a9rdfb6df7d10c849c5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RuXu W. wrote:
> No, I havn't reset my card.
> after i got connected  with AP, after several minutes, kernel hangup.
> some kernel panic message, I writen from screen.
> 
> Caused by (from SRR1 = 149030) : Transfer error ack signal
> Opps: Machine check, sig: 7[#1]
> 
> ioread <==  ssb_pci_read32 <==  __do_softirq <==  b43_interrupt_handler
> 
> I load b43 module with qos=0

When I post a message with the mailing list Cc'd, please do a reply to all. That
way everyone can see the exchange. In addition, people that know more than I do
can post an answer.

The above error message certainly looks like a hardware error to me.

