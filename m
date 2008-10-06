Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33282 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYJFTMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 15:12:18 -0400
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 21:12:34 +0200
Message-Id: <1223320354.11272.224.camel@violet.holtmann.net> (sfid-20081006_211226_969259_9507B5E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> > This makes the code surrounding the last few things using
> > IWL_SET_BITS16 actually readable and removes the macros
> > so nobody will ever consider using them again.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> I don't want these macros eithers but I NACK any patches with cursing
> in the commit logs.

did I miss an internal joke here? I fail to see the cursing ;)

Regards

Marcel


