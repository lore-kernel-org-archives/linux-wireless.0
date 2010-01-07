Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60679 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab0AGOT7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 09:19:59 -0500
Date: Thu, 7 Jan 2010 15:19:57 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: gregkh@suse.de
cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Commit v2.6.31.10~7 breaks compilation
Message-ID: <alpine.LSU.2.01.1001071518030.24304@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey guys,


just wanting to let you know that v2.6.31.10~7 is not appropriate for 
2.6.31, as there is no "ps_default" field in struct wiphy,
and thus compilation of the module fails.


Jan

