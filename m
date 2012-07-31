Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44718 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab2GaNdq (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 31 Jul 2012 09:33:46 -0400
Received: by vcbfk26 with SMTP id fk26so5791338vcb.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2012 06:33:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120731133213.GB3606@redhat.com>
References: <1343739105-19091-1-git-send-email-machen@suse.com>
	<20120731133213.GB3606@redhat.com>
Date: Tue, 31 Jul 2012 21:33:27 +0800
Message-ID: <CALx5=V8RtNvHFWNfBHyfx1GvAikA8tZGqHR0oQXAuVeu9RiUQA@mail.gmail.com> (sfid-20120731_153417_391191_E77B8A83)
Subject: Re: [rt2x00-users] [PATCH v3] rt2x00 : fix rt3290 resuming failed.
From: Matt Chen <machen@suse.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: users@rt2x00.serialmonkey.com, kevin.chou@mediatek.com,
	woody.hung@mediatek.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/31 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Tue, Jul 31, 2012 at 08:51:45PM +0800, Chen, Chien-Chia wrote:
>>       u32 reg;
>>
>> +     int retval;
> Keep declarations together.
OK, will do. :)
> Stanislaw
>



-- 
Thank you.
