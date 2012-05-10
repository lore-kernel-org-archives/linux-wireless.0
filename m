Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab2EJQJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 12:09:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] iwlwifi updates
Date: Thu, 10 May 2012 18:09:05 +0200
Message-Id: <1336666148-24471-1-git-send-email-johannes@sipsolutions.net> (sfid-20120510_180919_101619_A783BE8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Here are a few more iwlwifi updates. We rename some functions to
get rid of the "agn" in them which we're using to indicate that
the function belongs to the current firmware API, and move a
macro that we'll need in a few more places.

johannes
