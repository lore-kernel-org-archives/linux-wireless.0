Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933794AbdACCmN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 21:42:13 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v032dCHg015174
        for <linux-wireless@vger.kernel.org>; Mon, 2 Jan 2017 21:42:12 -0500
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27r0u8vu4s-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jan 2017 21:42:11 -0500
Received: from localhost
        by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
        Tue, 3 Jan 2017 12:42:09 +1000
Subject: Re: kernel 4.9 iwlwifi startup error
To: Fabio Coatti <fabio.coatti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <2029482.jt8IarKZJs@calvin>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Tue, 3 Jan 2017 13:42:05 +1100
MIME-Version: 1.0
In-Reply-To: <2029482.jt8IarKZJs@calvin>
Content-Type: text/plain; charset=windows-1252; format=flowed
Message-Id: <942b4775-6027-2b99-84c7-37b7cde124b9@au1.ibm.com> (sfid-20170103_034227_592959_0B28F147)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/17 21:12, Fabio Coatti wrote:
> Hi all,
> I'm using kernel 4.9 and maybe half of the times I boot my laptop I get the
> error reported below, and the wifi does not work. I have to remove iwlwifi (like
> modprobe -r iwldvm iwlwifi) and insert it again to get things workig again.
> This seems a bit random, it does not happens all the times so it could be a
> timing issue or even a flaky hardware (unlikely, as I see only this issue with
> wifi, once it starts it works just fine)
> I'm pretty sure to have seen the same behaviour at some point in 4.8.X
> release, but right now I lost the related notes.
> Environment:
> Distro: gentoo
> gcc 5.4.0
> HW: Hewlett-Packard HP EliteBook Folio 9470m/18DF, BIOS 68IBD Ver. F.63
> 04/26/2016
> Intel(R) Core(TM) i5-3427U CPU @ 1.80GHz
> Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 24)
>
> Of course if more info is needed, just drop me a note.
>
> I'm not subscribed to mailing lists, so please keep me in CC: for any
> information request.
>
> Many thanks.

I've so far seen this once on my laptop, a Samsung NP540U3C (don't have 
it with me right now, so I'm not sure what the wifi chipset is), running 
with a Debian 4.9 kernel.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
