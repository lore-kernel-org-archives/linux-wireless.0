Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58728 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbbAFK4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:56:09 -0500
Message-ID: <1420541766.1966.18.camel@sipsolutions.net> (sfid-20150106_115615_591316_7E790C4F)
Subject: Re: [PATCH 2/2] cfg80211: avoid reg-hints in self-managed only
 systems
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 06 Jan 2015 11:56:06 +0100
In-Reply-To: <1420112563-3981-2-git-send-email-arik@wizery.com> (sfid-20150101_124249_204906_78CCC525)
References: <1420112563-3981-1-git-send-email-arik@wizery.com>
	 <1420112563-3981-2-git-send-email-arik@wizery.com>
	 (sfid-20150101_124249_204906_78CCC525)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-01-01 at 13:42 +0200, Arik Nemtsov wrote:
> When a system contains only self-managed regulatory devices all hints
> from the regulatory core are ignored. Stop hint processing early in this
> case. These systems usually don't have CRDA deployed, which results in
> endless (irrelevent) logs of the form:
> cfg80211: Calling CRDA to update world regulatory domain

Applied.

johannes

