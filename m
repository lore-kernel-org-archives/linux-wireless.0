Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:19127 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762396AbXHHWE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 18:04:56 -0400
Received: by ug-out-1314.google.com with SMTP id j3so276067ugf
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2007 15:04:54 -0700 (PDT)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: arm allmodconfig
Date: Thu, 9 Aug 2007 00:10:12 +0200
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
References: <20070808145705.756597b0.akpm@linux-foundation.org>
In-Reply-To: <20070808145705.756597b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708090010.12347.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<snip>

> drivers/net/wireless/rt61pci.c:2034: warning: comparison is always false due to limited range of data type
> drivers/net/wireless/rt61pci.c:2047: warning: comparison is always false due to limited range of data type
> drivers/net/wireless/rt61pci.c:2050: warning: comparison is always false due to limited range of data type

Thanks, will fix these asap.

Ivo

