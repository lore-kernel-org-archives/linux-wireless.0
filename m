Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61991 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab2FGSSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 14:18:15 -0400
Date: Thu, 7 Jun 2012 11:18:12 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: Arend van Spriel <arend@broadcom.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH 4/8] brcm80211: smac: inform mac80211 of the X2
 regulatory domain
Message-ID: <20120607181812.GD4603@tux> (sfid-20120607_201819_064185_48FA1AD9)
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-5-git-send-email-seth.forshee@canonical.com>
 <4FC008AB.4080107@broadcom.com>
 <20120526171800.GC11759@ubuntu-mba>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120526171800.GC11759@ubuntu-mba>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 26, 2012 at 12:18:00PM -0500, Seth Forshee wrote:
> My understanding of DFS is pretty rudamentary. Could you explain what
> support is needed? I do see that mac80211 doesn't really support power
> measurement requests, but if we can at least stop transmission when
> radar is present couldn't we still operate on the channels?
> 
> Luis, any insight you can offer on the subject would be appreciated.

You can forget about DFS master support at this point. DFS client mode
is handled by mac80211 though.

  Luis
