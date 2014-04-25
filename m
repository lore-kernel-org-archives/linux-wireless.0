Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:59542 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaDYJ5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 05:57:01 -0400
Received: by mail-ob0-f177.google.com with SMTP id wp18so3894005obc.36
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 02:57:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <535A2FC2.4080508@gmail.com>
References: <CA+V6dmjwfsrDSDQWHHCFbW9L14GnzifoSjH5UOS4zTSusRtYow@mail.gmail.com>
 <535A13FA.4070405@gmail.com> <CA+V6dmjcYxTjYyjk7kd2-=ijXyqvWL=8bV1YQ0ejeSAK62qapw@mail.gmail.com>
 <535A2FC2.4080508@gmail.com>
From: Pierre Bourdon <delroth@gmail.com>
Date: Fri, 25 Apr 2014 11:56:40 +0200
Message-ID: <CA+V6dmiRHjviCjv7+1i8+EVfYEo47SodYUDQPBrX9rdBAx6h2A@mail.gmail.com> (sfid-20140425_115709_543143_CE30D7BE)
Subject: Re: Odd network behaviors with an Intel Wireless 7260
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ryan Houdek <sonicadvance1@gmail.com>, tilkax@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 25, 2014 at 11:49 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Hmm... What kernel are you using?
> IIRC 22.1.7.0 doesn't have uAPSD support - so if it the problem exists with this firmware, then we should look for something else.

Currently using Linux 3.13.8 and firmware 22.24.8.0. I don't remember
precisely what fw versions I tried before and I cannot really try
several mitigations at once so let's wait and see if disabling
power_save changes anything.

-- 
Pierre "delroth" Bourdon <delroth@gmail.com>
Software Engineer @ Zürich, Switzerland
http://code.delroth.net/
