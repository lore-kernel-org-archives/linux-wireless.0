Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:33276 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753451Ab1F3TFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 15:05:41 -0400
Message-ID: <4E0CC8FC.9050906@boundarydevices.com> (sfid-20110630_210545_559936_D6C3489B)
Date: Thu, 30 Jun 2011 12:05:32 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
MIME-Version: 1.0
To: mangesh gadre <mangeshgadre07@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: WL1271: WLAN_IRQ not working
References: <4E0942CA.9010402@boundarydevices.com> <BANLkTimKSfgE7SOPVDhvOcDB5ox6uyPc_Q@mail.gmail.com>
In-Reply-To: <BANLkTimKSfgE7SOPVDhvOcDB5ox6uyPc_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/29/2011 11:24 PM, mangesh gadre wrote:
> Hi,
> 
> Please check if your wifi enable pin is in right state. secondly check if
> regulator section of your chip is actually powering up wifi internal core .
> check your circuit against standard ref circuit.
> I have seen similar issue and there was some resistor missing in feedback
> path of volatge regulator output path from chip. Most probably wifi section
> of your chip is not powered up.

I think the problem is solved, but can you point me to a "standard ref
circuit" for TiWiR2. Maybe, I can avoid future problems.



Thanks
Troy
