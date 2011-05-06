Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43438 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1EFXvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 19:51:01 -0400
Received: by qwk3 with SMTP id 3so2248569qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 16:51:01 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 7 May 2011 01:51:00 +0200
Message-ID: <BANLkTik3TtCcy2cJkMbRTpsn4x4XE9=naQ@mail.gmail.com> (sfid-20110507_015121_000308_D91E6AD4)
Subject: Biescting between mainline and wireless-testing
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I suspect we have some ugly (hard trackable) regression between
mainline and wireless-testing. It sounds impossible, but this seems to
affect Broadcom cards and looks like not related to ssb or b43.

Today I've compiled 2.6.38 and 2.6.39-rc6, both work GOOD.
I've compiled wireless-testing and it failed, BAD.
I've reverted all recent ssb patches from top and it still fails BAD.

What would be the easiest way to try bisecting? I can see
wireless-testing merges mainline quite often. Can I use some trick on
checkouted wireless-testing? Do I have to checkout mainline and merge
wireless-testing into it? Something even different?

-- 
Rafał
