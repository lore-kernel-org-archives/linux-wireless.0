Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64973 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1BBWlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 17:41:36 -0500
Received: by pzk35 with SMTP id 35so96793pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 14:41:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D45B7B2.40001@davizone.at>
References: <4D45A583.3060605@davizone.at>
	<4D45B7B2.40001@davizone.at>
Date: Thu, 3 Feb 2011 00:41:35 +0200
Message-ID: <AANLkTi=xN8EKB+gih4_XxcgCJ0g3B9Q8tfJ5JuNJgCqu@mail.gmail.com>
Subject: Re: [PATCH 00/18] wl1251: feature ports / monitor mode / packet injection
From: Grazvydas Ignotas <notasas@gmail.com>
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	"Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 9:10 PM, David Gnedt <david.gnedt@davizone.at> wrote:
> Patch 01-03 fix some bugs.
> Patch 04-09 contain some feature ports from Maemo Fremantle and wl1271.
> Patch 10-18 implement (mainly) monitor mode and packet injection.

Just tried this on pandora board with 2.6.37 kernel and everything
seems to be fine. Haven't tested monitor mode or packet injection
though, so for fixes and feature ports:
Tested-by: Grazvydas Ignotas <notasas@gmail.com>
