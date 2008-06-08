Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:46811 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbYFHQMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 12:12:55 -0400
Received: by an-out-0708.google.com with SMTP id d40so422697and.103
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 09:12:55 -0700 (PDT)
Message-ID: <43e72e890806080912o7d186120r8ce70c46ca3526de@mail.gmail.com> (sfid-20080608_181258_027296_920D10CA)
Date: Sun, 8 Jun 2008 09:12:54 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Dad <ccmcphe@verizon.net>
Subject: Re: Compatibility Issues with compat-wireless-2008-05-22
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <483D99DC.4020909@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <483D99DC.4020909@verizon.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2008 at 10:43 AM, Dad <ccmcphe@verizon.net> wrote:
> I am building with kernel 2.6.22-14 and I have some build problems with any
> compat-wireless build past 05-21. The builds show a problem with the
> function skb_get_queue_mapping not being defined and a define
> NETIF_F_MULTI_QUEUE not being defined. Complete list is below. I have
> checked my linux source and includes for theses references and cannot find
> them anywhere. Is there a way to make the builds compatable?

This required backport support of MQ, please try now.

  Luis
