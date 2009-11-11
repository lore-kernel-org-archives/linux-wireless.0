Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:10797 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbZKKLN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 06:13:29 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iw: display noise level from survey data
Date: Wed, 11 Nov 2009 12:12:48 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200911111136.34949.holgerschurig@gmail.com>
In-Reply-To: <200911111136.34949.holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911111212.48904.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This no longer works against wireless-testing, because some 
NL80211_ATTR_SURVEY_INFO has changed the number from 53 to 54 
(in wireless-testing). So before/after appyling, nl80211.h 
should be harmonized between iw and wireless-testing.

-- 
http://www.holgerschurig.de
