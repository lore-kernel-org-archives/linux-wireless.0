Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:5104 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbZASL5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 06:57:10 -0500
Received: by ey-out-2122.google.com with SMTP id 22so496926eye.37
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 03:57:09 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 19 Jan 2009 13:50:32 +0200
Message-ID: <eb3ff54b0901190350j74151192he854ba579d3c8709@mail.gmail.com> (sfid-20090119_125714_099452_D66E383B)
Subject: [PATCH 2/4] mac80211: trivial documentation fixes (enum
	mesh_path_flags).
From: Rami Rosen <ramirose@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	luisca@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes documentation of enum mesh_path_flags in mesh.h.

Signed-off-by: Rami Rosen <ramirose@gmail.com>

--
(wireless-testing)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index c5b0b58..f1196f5 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -24,15 +24,15 @@
  *
  *
  *
- * @MESH_PATH_ACTIVE: the mesh path is can be used for forwarding
- * @MESH_PATH_RESOLVED: the discovery process is running for this mesh path
+ * @MESH_PATH_ACTIVE: the mesh path can be used for forwarding
+ * @MESH_PATH_RESOLVING: the discovery process is running for this mesh path
  * @MESH_PATH_DSN_VALID: the mesh path contains a valid destination sequence
  * 	number
  * @MESH_PATH_FIXED: the mesh path has been manually set and should not be
  * 	modified
  * @MESH_PATH_RESOLVED: the mesh path can has been resolved
  *
- * MESH_PATH_RESOLVED and MESH_PATH_DELETE are used by the mesh path timer to
+ * MESH_PATH_RESOLVED is used by the mesh path timer to
  * decide when to stop or cancel the mesh path discovery.
  */
 enum mesh_path_flags {
