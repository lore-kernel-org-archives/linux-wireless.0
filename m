Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:14924 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYLWXhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 18:37:09 -0500
Message-ID: <81b0412b0812231537g3a1a0527xf28aa9945c7ca3d9@mail.gmail.com> (sfid-20081224_003715_810954_9401C2C4)
Date: Wed, 24 Dec 2008 00:37:08 +0100
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net, "Jim Paris" <jim@jtan.com>,
	linville@tuxdriver.com
Subject: [Bug 11326] iwl3945: Error: Response NULL in 'REPLY_ADD_STA', followed by fault
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any chance that at least the patch in the bug's discussion is accepted
in the next stable?

http://bugzilla.kernel.org/show_bug.cgi?id=11326

I tested the patch, and if the error message is still seen sometimes,
there is no crash
and the system can be shutdown properly (in its other parts). It maybe even more
useful to the original reporter of the problem, who experienced it on
a running system.
