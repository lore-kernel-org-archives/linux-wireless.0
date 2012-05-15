Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.serverraum.org ([78.47.150.89]:49948 "EHLO
	mail.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab2EOMOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 08:14:55 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.serverraum.org (Postfix) with ESMTP id BDE913EFF0
	for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 14:14:54 +0200 (CEST)
Received: from mail.serverraum.org ([127.0.0.1])
	by localhost (web.serverraum.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id luvbLKeCQKYr for <linux-wireless@vger.kernel.org>;
	Tue, 15 May 2012 14:14:54 +0200 (CEST)
Received: from mail-ob0-f174.google.com (mail-ob0-f174.google.com [209.85.214.174])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by mail.serverraum.org (Postfix) with ESMTPSA id 6C8FC3EFEF
	for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 14:14:51 +0200 (CEST)
Received: by obbtb18 with SMTP id tb18so8843103obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 05:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3=G_ooQ_ODCKPXQxt9vkJZpbRV083CUBitof5mEVo6kw@mail.gmail.com>
References: <CADYPuQ5U-TeJvaWdLA=kTgLRacMRyEPoi2aoB=PV-cx_YDXotg@mail.gmail.com>
	<CANUX_P3=G_ooQ_ODCKPXQxt9vkJZpbRV083CUBitof5mEVo6kw@mail.gmail.com>
Date: Tue, 15 May 2012 14:14:49 +0200
Message-ID: <CADYPuQ54joKvzJEyTU+sjHFCPDqzizZL7_HfJwLi9VE-=+ETVQ@mail.gmail.com> (sfid-20120515_141459_383606_10C51886)
Subject: Re: frequent disconnects with iwlwifi
From: Philipp Dreimann <philipp@dreimann.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: sedat.dilek@googlemail.com, johannes.berg@intel.com,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 May 2012 13:18, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Mon, May 14, 2012 at 10:39 PM, Philipp Dreimann <philipp@dreimann.net> wrote:
> Sedat, your business is doing well. You have another customer. This is
> a bug in NM. Sedat will provide details :-)

I saw Sedat's posts and wanted to try disabling ipv6 handling in NM
first to see if it helps. And, yes, it does.

Cheers
