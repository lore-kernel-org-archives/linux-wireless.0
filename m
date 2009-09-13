Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f191.google.com ([209.85.210.191]:61987 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbZIMOwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2009 10:52:10 -0400
Received: by yxe29 with SMTP id 29so2944384yxe.16
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2009 07:52:13 -0700 (PDT)
Message-ID: <4AAD05D5.4030606@lwfinger.net>
Date: Sun, 13 Sep 2009 09:46:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Problem with compat-wireless build
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the link at
http://ubuntuforums.org/showpost.php?p=7940247&postcount=92, a problem
with building compat-wireless on 2.6.28 is described. A posting on the
openSUSE forum states that this started with the 06-09-2009 release.
>From the error message, it is due to the threaded interrupt code in
b43. That may be difficult to fix as this change exposed a
long-standing kernel bug that also needed to be fixed.

Larry
