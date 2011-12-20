Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61833 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab1LTUYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 15:24:07 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 0/3] cfg80211: reliense the rest of regulatory to ISC
Date: Tue, 20 Dec 2011 12:23:35 -0800
Message-ID: <1324412618-25131-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_212412_001649_DAFACC85)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

I'm working on a regulatory revamp of the kernel's regulatory code. In
this pursuit I've started working on code loosely based on what I had
originally written but starting in userspace [1] to help easily
simulate, and test new designs, and run the code through some test
cases. Additionally given some recent interest and a lot of
development from the FreeBSD in wireless *and* me getting tired of
dealing with crap proprietary code in this area I'm inclined to help
try to unify architecture design and code between other OSes as much
as possible. I may even be able to convince a few folks to consider
using this code for usage in some other OSes as well but my focus for
now is at least Linux and seeing if FreeBSD might be interest in
collaboration.

I have obtained ACKs from all the contributors except two entities who
have died, but made single minor contributions. These patches deal with
those few minor contributions and relicense the remaining regulatory
code on cfg80211 to ISC.

[0] git://github.com/mcgrof/regsim.git

Luis R. Rodriguez (3):
  cfg80211: replace reg.c Nokia commit c4c32294
  cfg80211: replace reg.c Nokia commit 269ac5
  cfg80211: relicense reg.c reg.h and genregdb.awk to ISC

 net/wireless/genregdb.awk |   13 ++++++++++---
 net/wireless/reg.c        |   35 ++++++++++++++++++++++-------------
 net/wireless/reg.h        |   15 +++++++++++++++
 net/wireless/regdb.h      |   16 ++++++++++++++++
 4 files changed, 63 insertions(+), 16 deletions(-)

-- 
1.7.4.15.g7811d

