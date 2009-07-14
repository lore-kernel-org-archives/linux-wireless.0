Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:41728 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbZGNWMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 18:12:09 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 14 Jul 2009 15:11:45 -0700
Message-ID: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com>
Subject: Generic events for wake up from S1-S4
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm working on Wake-on-Wireless support for wireless right now [1].
Upon wake up I wanted to inform the kernel of the event which caused
the wake up but am not clear if there is a generic API for this. Mind
you, for WoW we'll need at least some AC power to the card so we'll
need to at least be in S3-Hot so we'll only need events for that for
now.

Do we have some generic infrastructure to gather reasons for wake up
from S1-S4 and pass this to userspace yet?

[1] http://wireless.kernel.org/en/users/Documentation/WoW

  Luis
