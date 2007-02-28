Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48611 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbXB1OHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:11 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562551nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:10 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/28] rt2x00:
Date: Wed, 28 Feb 2007 15:07:04 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.04933.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the patch series to bring rt2x00 up to date.
The main features this series presents are:
	- debugfs support (reading/writing registers)
	- rt2x00lib (Move generic code to a seperate module)
	- sparse fixes

This series also fixes countless of bugs, although several new
ones have been introduced. All rt2x00 drivers should now
be far better at supporting master mode. Alhtough rt73usb is
no longer capable of receiving any data.

Sparse is not completely silent about rt2x00, except for the
rt2x00debug module. sparse simply gives a warning about
unnamed initializors in the file_operation structures and then
simply crashes. I have been unable to see what the exact cause
of the problem is.

For this patch series I have been experimenting with git/cogito a bit,
so perhaps next patch series will be a git pull request instead of 30 mails. ;)

Ivo
