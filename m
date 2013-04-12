Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:64826 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3DLQTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 12:19:47 -0400
Received: by mail-ob0-f175.google.com with SMTP id va7so2557209obc.34
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2013 09:19:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365779338-8224-1-git-send-email-hauke@hauke-m.de>
References: <1365779338-8224-1-git-send-email-hauke@hauke-m.de>
Date: Fri, 12 Apr 2013 18:19:46 +0200
Message-ID: <CACna6ryALXd6-=UciKJrMJ8PjmPyTXjPL1vJdWOmtBRSciO8Ew@mail.gmail.com> (sfid-20130412_181950_757407_FC29464A)
Subject: Re: [PATCH v3] b43: use bcma_pmu_spuravoid_pllupdate()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/12 Hauke Mehrtens <hauke@hauke-m.de>:
> Do not implement this in b43, but use bcma_pmu_spuravoid_pllupdate().

Ack

-- 
Rafał
