Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36906 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbKWWIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 17:08:22 -0500
Received: by igcto18 with SMTP id to18so1111239igc.0
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2015 14:08:22 -0800 (PST)
Date: Mon, 23 Nov 2015 16:07:19 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Robert <robert.offenbacker@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RegulatoryDB
Message-ID: <20151123220719.GA3857@ubuntu-hedt> (sfid-20151123_230825_965486_7CB0F71E)
References: <56537C2D.8030506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56537C2D.8030506@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2015 at 03:50:53PM -0500, Robert wrote:
>     For Educational/Learning Purposes I am attempting to change some
> information in this database... Is it possible to change data within
> this binary file?

You can make changes to db.txt and then build a new binary database from
that. Have a look at
https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb
for more information, and let me know if you have questions which aren't
answered there.

Seth
