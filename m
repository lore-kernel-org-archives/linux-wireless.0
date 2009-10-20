Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:3362 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZJTWKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 18:10:07 -0400
Message-ID: <e3511b0c31dd03889a221c947dec2c80.squirrel@webmail.xs4all.nl>
In-Reply-To: <4ADE2773.8020507@gmail.com>
References: <4ADE2773.8020507@gmail.com>
Date: Wed, 21 Oct 2009 00:10:09 +0200
Subject: No support for Fritz!WLAN USB N2.4
From: "Ed Vaessen" <evaessen@xs4all.nl>
To: "LKML" <linux-kernel@vger.kernel.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To my surprise I found that it seems that the driver for Fritz!WLAN USB
N2.4 is not longer supported. At least, the last tarballs I got do not
compile them anymore. Their code is still there but no module with the
name ar9170 is built. Modules from the same group, like ath5k and ath9k
are built.
Am I missing something?





