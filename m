Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41713 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0LWGUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 01:20:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PVeWy-00075f-Tt
	for linux-wireless@vger.kernel.org; Thu, 23 Dec 2010 07:20:05 +0100
Received: from ool-4a5955a5.dyn.optonline.net ([74.89.85.165])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 23 Dec 2010 07:20:04 +0100
Received: from erappleman by ool-4a5955a5.dyn.optonline.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 23 Dec 2010 07:20:04 +0100
To: linux-wireless@vger.kernel.org
From: Eric Appleman <erappleman@gmail.com>
Subject: iwlwifi: Intel 3945ABG speed issues finally identified. 
Date: Thu, 23 Dec 2010 06:15:18 +0000 (UTC)
Message-ID: <loom.20101223T071403-99@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I spent most of the day bisecting and testing numerous kernels and my work has
finally paid off.

I've found 2 candidate commits.

a6866ac93e6cb68091326e80b4fa4619a5957644
1402364162afbaac1b8a74ee21aeb013e817ac7d

iwl3945 definitely broke between 2.6.35-rc2 and -rc3.

