Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35460 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbbLGQIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 11:08:53 -0500
Received: by obbnk6 with SMTP id nk6so117310230obb.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2015 08:08:52 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [RFC] Documentation: Clarify wording regarding submission of wireless patches to stable
Date: Mon,  7 Dec 2015 10:08:50 -0600
Message-Id: <1449504530-9373-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20151207_170858_303894_B83142AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The instructions for submitting patches state that changes destined for
networking should not be marked with a Cc to stable. This restriction does
not apply to the wireless portion of networking. The instructions are
updated to clarify this case.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Kalle,

Is this change clear, and strong enough?

Larry
---

 Documentation/SubmittingPatches | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index d603fa0..5457a18 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -306,7 +306,9 @@ file.
 Note, however, that some subsystem maintainers want to come to their own
 conclusions on which patches should go to the stable trees.  The networking
 maintainer, in particular, would rather not see individual developers
-adding lines like the above to their patches.
+adding lines like the above to their patches. Note: Patches for the wireless
+section of networking should include a recommendation for inclusion in stable
+whenever appropriate.
 
 If changes affect userland-kernel interfaces, please send the MAN-PAGES
 maintainer (as listed in the MAINTAINERS file) a man-pages patch, or at
-- 
2.1.4

