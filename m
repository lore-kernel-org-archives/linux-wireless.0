Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab3HAPCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 11:02:08 -0400
Message-ID: <1375369316.8608.16.camel@jlt4.sipsolutions.net> (sfid-20130801_170211_986931_F6EADFFF)
Subject: Re: [PATCHv5 0/4] add master channel switch announcement support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 01 Aug 2013 17:01:56 +0200
In-Reply-To: <1373551749-5107-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373551749-5107-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 16:09 +0200, Simon Wunderlich wrote:
> This is the 5th edition of the CSA support patch series. This patchset adds
> generic channel switch support for AP. This is required for DFS operation
> (e.g. Wi-Fi Alliance requires this for 802.11h certification). This will also
> be required for IBSS-DFS later.

Applied 1-3 with some changes (merging 2/3 and small fixes)

johannes

