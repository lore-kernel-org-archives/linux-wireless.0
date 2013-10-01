Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3JALDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:03:35 -0400
Message-ID: <1380625412.14430.18.camel@jlt4.sipsolutions.net> (sfid-20131001_130338_349102_6CD80BC9)
Subject: Re: [PATCH] Don't get iw version from git if there is no .git/
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Schmaus <fschmaus@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 13:03:32 +0200
In-Reply-To: <1378482070-8863-1-git-send-email-fschmaus@gmail.com>
References: <1378482070-8863-1-git-send-email-fschmaus@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-09-06 at 17:41 +0200, Florian Schmaus wrote:
> The version.sh script should only try to get the version from git if the
> source actually resides in a git repository, i.e. .git/ exists. Doing
> otherwise in a non-git source repo results in git ascending until it
> finds a .git directory, which will cause problems in some source-based
> distributions ( https://bugs.gentoo.org/show_bug.cgi?id=482334 ).

Applied.

johannes

