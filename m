Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:26056 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbXI0SAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 14:00:11 -0400
Received: by py-out-1112.google.com with SMTP id u77so4958071pyb
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2007 11:00:10 -0700 (PDT)
Message-ID: <43e72e890709271100n39f16c18x723dc7a85d418666@mail.gmail.com>
Date: Thu, 27 Sep 2007 14:00:09 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: New 'Changes-licensed-under' tag introduced for Linux-wireless
Cc: "linux kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Our guidelines for patches [1] for Linux-wireless has been updated.
One section asks Linux-wireless developers to subscribe to the patch
guideline wiki page (section 2) and another which introduces the new
'Changes-licensed-under' (section 10).

Here I'll cover the new 'Changes-licensed-under' tag but please refer
to the link and subscribe to the page for the complete details and for
further changes.

--

Based on the new guidelines posted by the SFLC on ''Maintaining
Permissive-Licensed Files in a GPL-Licensed Project: Guidelines for
Developers'' [2], specifically section 5, we are introducing a new tag
for use with patches which deal with files licensed under permissive
licenses (BSD, ISC) on Linux wireless in our larger GPL project, the
Linux kernel. The tag is Changes-licensed-under and can be used by
developers to clarify the intended license for their patch on
permissive licensed files. It is clear that not all changes qualify a
patch author for Copyright but a lot of patches do qualify an author
for copyright. If you want crystal clear details of what constitutes
as a copyrightable change, at least within the US and the EU, you can
refer to SFLC's ''Originality Requirements under U.S. and E.U.
Copyright Law'' [3].

Although some developers have a practice of implying their patches for
a permissive licensed file abides by the respective permissive license
of the file being patched, and although some changes are obviously not
copyrightable, we would like to ''err on the side of caution'', take
the advice from SFLC, and introduce Changes-licensed-under in order to
help the BSD family reap benefits of our contributions to permissive
licensed files.

The Changes-licensed-under tag should be put before the Signed-off-by
tag. Since this tag is used to cover changes under permissive licenses
example of possible licenses are 3-Clause-BSD, and ISC. If you are
making changes to multiple permissive licensed files then please
specify which license covers what files.

--

For examples of using this tag please refer to the guidelines.

[1] http://linuxwireless.org/en/developers/SubmittingPatches
[2] http://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html
[3] http://www.softwarefreedom.org/resources/2007/originality-requirements.html

  Luis
