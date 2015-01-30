Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:57665 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbbA3T0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 14:26:24 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 30 Jan 2015 11:26:02 -0800
Message-ID: <CAB=NE6UM-=ARNqwyxk0a_qve+9Ndk1znsm+FjfXq+xenCkTvCQ@mail.gmail.com> (sfid-20150130_202640_007594_57225D87)
Subject: [ANN] crda-3.18 released
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new release of CRDA has been released, this might be the last since
we have some ideas of how to just shift this functionality directly
into the kernel and in the future may not need any userspace tool
other than to help debug stuff perhaps. The major thing here is
trusting Seth's new key as he is now the maintainer of the
wireless-regdb. Other than this it also add AUTO-BW rule support,
parse/print of CAC on db2rd, and fixes a compile error. This release
goes signed with my new PGP key.

Thanks to all who have contributed. There release page for CRDA:

http://drvbp1.linux-foundation.org/~mcgrof/rel-html/crda/

The v3.18 release:

http://kernel.org/pub/software/network/crda/crda-3.18.tar.xz

The wireless-regdb release page:

http://drvbp1.linux-foundation.org/~mcgrof/rel-html/wireless-regdb/

As announced by Seth, the new wireless-regdb is:

http://kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2015.01.30.tar.xz

The shortlog of this CRDA v3.18 release:

mcgrof@garbanzo ~/devel/crda (git::master)$ git shortlog v3.13..v3.18
Janusz Dziedzic (4):
      crda: sync with latest nl80211.h
      crda: add AUTO-BW rule flag support
      crda: simplify text parsing for country/rules
      crda: db2rd, parse/print CAC time

John W. Linville (1):
      crda: Add DESTDIR support in install-libreg* rules in Makefile

Krishna Chaitanya (1):
      crda: Fix the linking order to avoid compilation error

Luis R. Rodriguez (1):
      crda: document contribution process using the DCO

Seth Forshee (1):
      crda: Trust regulatory.bin from Seth Forshee
