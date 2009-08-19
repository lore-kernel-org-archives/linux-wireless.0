Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.211.173]:64966 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZHSSzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 14:55:35 -0400
Received: by ywh3 with SMTP id 3so127357ywh.22
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 11:55:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250679220-30392-1-git-send-email-vasanth@atheros.com>
References: <1250679220-30392-1-git-send-email-vasanth@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 19 Aug 2009 11:55:16 -0700
Message-ID: <43e72e890908191155j23107975gf244bbc7194cd06b@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix bug in retrieving average beacon
	rssi
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	Jouni.Malinen@atheros.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 3:53 AM, Vasanthakumar
Thiagarajan<vasanth@atheros.com> wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Vasanth, can you provide a little more description here on the commit
log as to what the issue was?

  Luis
