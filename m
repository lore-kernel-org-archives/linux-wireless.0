Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57932 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYKAXS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 19:18:57 -0400
Cc: linux-wireless@vger.kernel.org
Message-Id: <FDF1BA6C-4A27-4458-870D-CC999FB4F390@holtmann.org> (sfid-20081102_001903_107910_EDAE8651)
From: Marcel Holtmann <marcel@holtmann.org>
To: Bernhard Schmidt <berni@birkenwald.de>
In-Reply-To: <geil9a$jdt$1@ger.gmane.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: Forcing/Forbidding specific band on iwlagn
Date: Sun, 2 Nov 2008 00:18:37 +0100
References: <geil9a$jdt$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bernhard,

> I have a rather user-side question, I don't know exactly whether I'm
> right in here :-)
>
> I have a Dell Latitude D630 with an Intel IWL4965AGN wireless card
> running Ubuntu 8.10 amd64 (Linux 2.6.27 -> iwlagn). It is pretty flaky
> and crashes my system at least once a day (when something happens with
> my wireless), but that will be the subject of another debugging  
> session.

that is highly like due to the iwl_tx_cmd_complete BUG_ON. Newer  
kernels changed it to a WARN_ON, but it is still not solved why this  
happens.

Regards

Marcel

