Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.183]:30866 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZAWXqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 18:46:35 -0500
Received: by el-out-1112.google.com with SMTP id b25so773639elf.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 15:46:33 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 23 Jan 2009 15:46:33 -0800
Message-ID: <43e72e890901231546y68635a9foead5bf2003ae16f5@mail.gmail.com> (sfid-20090124_004638_903081_B0B19A92)
Subject: CRDA and wireless-regdb packaging
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>, mcgrof@tmo.blackberry.net,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Tim

I have searched for CRDA on -proposed on jaunty and don't see it yet.
I searched the net and found your PPA and your packages so I gave
wireless-crda a shot but I noticed it doesn't install crda, only
documentation, perhaps I'm not looking in the right place. Anyway
since debian didn't have a package, and I then noticed some issues
with the wireless-regdb package I installed and I really wish crda and
wireless-regdb is separated I didn't want to bug you about it as I
know you have your plate full and decided to just give packaging them
a shot.

I've separated into two packages:

crda
wireless-regdb

This allows regulatory updates to be completely separate from crda.
I've also added man pages for wireless-regdb and crda stuff. The
packages I built use cdbs which make the debian/rules short and sweet.
I sent the stuff to John as a patch under debian-example. I've also
put my own stuff under crda's debian-example.

  Luis
