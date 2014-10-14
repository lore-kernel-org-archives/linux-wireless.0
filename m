Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55445 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaJNJTQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 05:19:16 -0400
Message-ID: <1413278329.2455.1.camel@jlt4.sipsolutions.net> (sfid-20141014_111918_704974_FE624733)
Subject: Re: [PATCH 1/2] cfg80211: Convert del_station() callback to use a
 param struct
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Oct 2014 11:18:49 +0200
In-Reply-To: <20141010175240.GA29287@jouni.qca.qualcomm.com>
References: <20141010175240.GA29287@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-10 at 20:52 +0300, Jouni Malinen wrote:
> This makes it easier to add new parameters for the del_station calls
> without having to modify all drivers that use this.

Applied.

johannes

