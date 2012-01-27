Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1033 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab2A0Lhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 06:37:43 -0500
Message-ID: <4F228C76.2010109@broadcom.com> (sfid-20120127_123808_343384_F9554CAA)
Date: Fri, 27 Jan 2012 12:37:26 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Milan Bouchet-Valat" <nalimilan@club.fr>
cc: "Milan Bouchet-Valat" <nalimilan@club-internet.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4313 keeps disconnecting with brcmsmac and multiple APs
References: <22905678.140637.1327401110095.JavaMail.www@wsfrf1232>
 <4F227784.10309@broadcom.com> <1327660003.21888.14.camel@milan>
In-Reply-To: <1327660003.21888.14.camel@milan>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2012 11:26 AM, Milan Bouchet-Valat wrote:
> Le vendredi 27 janvier 2012 à 11:08 +0100, Arend van Spriel a écrit :
>> Another thing to consider. I notice that you have a bluetooth device in
>> there as well. Can you disable that (if possible) and try again.
> I'll try that, but sadly not before Tuesday as I'm not in the right
> place ATM.

Ok. To disable bluetooth you could use the rfkill utility:

$ rfkill block bluetooth

>> Does your AP have DFS enabled?
> I'll ask my IT staff about that. Or is there a way to get this
> information from the logs or iwconfig?
> 

I actually did mean whether the AP has automatic channel selection. I am
not sure whether it is advertised in the beacons.

Gr. AvS

