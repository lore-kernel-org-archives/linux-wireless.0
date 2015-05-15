Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34951 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbbEOK7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 06:59:32 -0400
Received: by iesa3 with SMTP id a3so17713990ies.2
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2015 03:59:31 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 May 2015 12:59:31 +0200
Message-ID: <CACna6rw47fBcRczzSjeE1xXdqVPKuwn7yGvbXv2wL8zg8O8pFA@mail.gmail.com> (sfid-20150515_125937_170156_FCB1F9A3)
Subject: ACS support (survey) in few various drives: carl9170, mwifiex, mwl8k,
 p54, rt2800*
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to follow ACS implementation in hostapd & kernel. I think I
managed to document what driver needs to implement to allow hostapd
use it with acs_survey option:
https://wireless.wiki.kernel.org/en/users/documentation/acs?&#driver_implementation_details

All sources say about only 3 drivers supporting ACS: ath5k, ath9k, ath10k.

However it seems there are more drivers with support for various
SURVEY_INFO_* stuff. From what I see ACS should work with following
ones just fine:
carl9170, mwifiex, mwl8k, p54, rt2800*

Am I missing something? Is there any reason ACS won't work with above drivers?

-- 
Rafał
