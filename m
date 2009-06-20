Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([207.115.11.54]:34297 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZFTDxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 23:53:38 -0400
Message-ID: <4A3C5D49.2000106@lwfinger.net>
Date: Fri, 19 Jun 2009 22:53:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Question about rfkill
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

What is the reason that rfkill_get_global_sw_state() is not exported?
A call to this routine seems to be the ideal replacement for the
deprecated radio_enabled.

Larry
