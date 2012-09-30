Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28549 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab2I3DXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 23:23:31 -0400
From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
Cc: Sujith Manoharan <c_manoha@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20583.47899.75784.778766@gargle.gargle.HOWL> (sfid-20120930_052415_589884_638C093A)
Date: Sun, 30 Sep 2012 08:53:07 +0530
To: Luiz Carlos Ramos <lramos.prof@yahoo.com.br>
Subject: Fwd: Re: Atheros AR9485 receiving error -5 in init [SOLVED]
In-Reply-To: <1348939164.30839.140661134325425.07BE8393@webmail.messagingengine.com>
References: <207925.414c3561696d494141546e6c55467952375171314f324a73417855@popretr.messagingengine.com>
	<1348939164.30839.140661134325425.07BE8393@webmail.messagingengine.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luiz Carlos Ramos wrote:
> Hello,
> 
> I changed the way the test of the new kmods was done, and it worked out
> of the box. Although no reply was received, I would like to thank you
> for your attention.
> 
> The details are here. The first tests performed was just like that:
> 
>   boot the OS -> load the original (2.6.38) kmods -> rmmod them ->
>   install the newer kmods (compat-wireless-3.5.3-2-sn)
> 
> I couldn't stop the load of the original kmods, until they were
> explictly blacklisted.
> 
> This leads to error -19 in the loading of the original kmods, and -5 in
> the newer ones.
> 
> Repeating the test this way everything works:
> 
>   boot the OS -> load the newer kmods (compat-wireless-3.5.3-2-sn)

Sorry, this thread fell off the radar. :)
Good to know that things are working, though !

Sujith

