Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0KXHRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 02:17:23 -0500
Subject: Re: [PATCH] iw: Resolve namespace clash between station plink and
 vlan commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikXhNM=LOsX3tdf=7RorGd=GSSLCTpDRDGMLZZE@mail.gmail.com>
References: <1289867251-21559-1-git-send-email-javier@cozybit.com>
	 <1289946246.3673.12.camel@jlt3.sipsolutions.net>
	 <AANLkTimuW8wTVUW4dH1t+J6jhoEkFHZ7v5t78tXe050O@mail.gmail.com>
	 <1289959503.29119.2.camel@jlt3.sipsolutions.net>
	 <AANLkTimFe7uo28u3Sx4rc9uYJms7Ggh=yW9UMDDWgQce@mail.gmail.com>
	 <1290500915.3674.1.camel@jlt3.sipsolutions.net>
	 <AANLkTikXhNM=LOsX3tdf=7RorGd=GSSLCTpDRDGMLZZE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 08:17:20 +0100
Message-ID: <1290583040.3790.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier,

> It works exactly as I hoped it would.  Thanks!
> (We only tested the plink_action alias, not the vlan)

Thanks for testing, I've applied it to my git repo.

johannes

