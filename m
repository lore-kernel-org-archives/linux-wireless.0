Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([91.250.116.113]:50049 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3KSQqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 11:46:50 -0500
Message-ID: <528B95F5.7070100@einfach.org> (sfid-20131119_174653_888497_E39D5904)
Date: Tue, 19 Nov 2013 16:46:45 +0000
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>, Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org
CC: Sujith Manoharan <sujith@msujith.org>,
	Ingo Randolf <ingo.randolf@qupik.com>, mcgrof@do-not-panic.com
Subject: Re: ath9k AR9382 high latency ping (solved)
References: <52492FB0.3010201@einfach.org>	<5249443E.3080700@rempel-privat.de>	<524954BE.8060603@einfach.org>	<52497C2E.1060406@rempel-privat.de>	<5249A2F7.5090908@einfach.org>	<524DA3DC.6060806@einfach.org> <21087.18050.72635.617321@gargle.gargle.HOWL> <52849677.3090609@einfach.org> <5284A50E.4080702@openwrt.org> <52850A7F.9090406@einfach.org>
In-Reply-To: <52850A7F.9090406@einfach.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/14/2013 05:38 PM, Bruno Randolf wrote:
> On 11/14/2013 10:25 AM, Felix Fietkau wrote:
>> Have you checked for IRQ issues? That seems likely given that packets
>> are sent, but the tx path is still considered hung.
> 
> Ha, thanks! You are certainly pointing me into the right direction (once
> again!):

Hi Felix, you were right, it was a interrupt issue and a BIOS upgrade
from the board vendor fixed it. Thanks!!!

bruno

