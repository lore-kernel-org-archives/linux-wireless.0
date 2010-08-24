Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59284 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0HXAak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 20:30:40 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 Aug 2010 17:30:20 -0700
Message-ID: <AANLkTikP7W9eQeqb3zdaCGdqqKddhBBQty_XsffGeNdB@mail.gmail.com>
Subject: Compat-wireless wireless-testing.git branch
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "wl" branch for compat-wireless.git is used to allow us to build
releases based on wireless-testing.git instead of linux-next.git. I
just ran into a few issues with porting some of the patches from the
master branch over which are now applicable to the "wl" branch but got
tired of trying to just nuked the "wl" branch, recreated a new one
based on the master branch and refreshed the patches to apply. If you
are a user of the "wl" branch you must:

git fetch
git checkout master
git branch -D wl
git checkout -b wl origin/wl

  Luis
