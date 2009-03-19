Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:56537 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZCSQpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 12:45:21 -0400
Received: by wf-out-1314.google.com with SMTP id 29so731858wff.4
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 09:45:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090319164256.GA25237@storm.local.network>
References: <20090319164256.GA25237@storm.local.network>
Date: Thu, 19 Mar 2009 09:45:19 -0700
Message-ID: <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com> (sfid-20090319_174525_758049_9605CBCD)
Subject: Re: VT6656 driver source now GPL
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 19, 2009 at 9:42 AM, Forest Bond <forest@alittletooquiet.ne=
t> wrote:
> Hi,
>
> VIA has released a new version of the VT6656 driver source, and it no=
w has a
> proper license!
>
> =C2=A0http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x86.zi=
p
>
> As you may recall, the previous version lacked a license altogether, =
making it
> unfit for distribution.
>
> I'd really like to see this driver integrated into the kernel. =C2=A0=
Does anyone care
> to comment regarding feasibility?

Indeed good news, what is the latest kernel it compiles for? If it
compiles on Linus' tree it can be stashed into staging while it gets
properly ported.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
