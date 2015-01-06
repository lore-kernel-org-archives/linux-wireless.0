Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58801 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbbAFLJj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 06:09:39 -0500
Message-ID: <1420542570.1966.23.camel@sipsolutions.net> (sfid-20150106_120943_028756_D6E08922)
Subject: Re: [PATCH v2] iw: fix android build
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Jan 2015 12:09:30 +0100
In-Reply-To: <1420541325-24052-1-git-send-email-arik@wizery.com> (sfid-20150106_114848_172845_1EF1C44A)
References: <1420541325-24052-1-git-send-email-arik@wizery.com>
	 (sfid-20150106_114848_172845_1EF1C44A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-06 at 12:48 +0200, Arik Nemtsov wrote:
> Don't define "iw" build target in the regular Makefile which gets
> included. This confuses the Android build system (coincides with module
> name).
> 
> Also correct libnl_2 to a be static library, as compiled on Android.

Applied, thanks.

johannes

