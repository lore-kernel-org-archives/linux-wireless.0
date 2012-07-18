Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44814 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2GRGzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 02:55:24 -0400
Received: by gglu4 with SMTP id u4so1242776ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jul 2012 23:55:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A478988B-A444-4FBA-B9FA-9DF5D17C949A@gmail.com>
References: <A478988B-A444-4FBA-B9FA-9DF5D17C949A@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 17 Jul 2012 23:55:03 -0700
Message-ID: <CAB=NE6W_c=1pdQj8WxiWaBBmZ9t8JiHqtNon6tz2RuaJcgxKBQ@mail.gmail.com> (sfid-20120718_085528_033622_FE5A6882)
Subject: Re: Mismatching sha-1 sums
To: Garrett Reid <garrett.reid@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 17, 2012 at 6:18 PM, Garrett Reid <garrett.reid@gmail.com> wrote:
> Hi guys,
>
> I was grabbing compat-wireless-3.5-rc5-1.tar.bz2 from http://wireless.kernel.org/en/users/Download/stable/, and my sha1sum mismatches.
>
> The page says I should have a checksum of d5908382831a2fdb79a5078fcc2ffaf49e914a1b, and I'm getting a checksum of d0c6bf8cda947143ad66cbfe79d4bec44fbbcc67.
>
> Is this expected?

No, I forgot to update the wiki with that new sha1sum, thanks for
reporting that, this is now fixed.

  Luis
