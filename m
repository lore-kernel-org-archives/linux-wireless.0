Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64576 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0ELHA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 03:00:57 -0400
Received: by fxm4 with SMTP id 4so224752fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 00:00:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273614705-25118-4-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
	 <1273614705-25118-4-git-send-email-gwingerde@gmail.com>
Date: Wed, 12 May 2010 09:00:56 +0200
Message-ID: <AANLkTimGXS2-H5AZQWNGD-i9et3ImZiSHQGQOOSuczIa@mail.gmail.com>
Subject: Re: [PATCH 3/9] rt2x00: Re-order tx descriptor writing code in
	drivers.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Where possible, write the tx descriptor words from start to end, to
> follow a logical ordering of words.
> Where this is not possible (in rt2400pci, rt2500pci and rt61pci) add
> a comment as to why word 0 needs to be written last.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
