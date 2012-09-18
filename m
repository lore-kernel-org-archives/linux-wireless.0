Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33557 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab2IRBN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 21:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6W9O-XvQUJgyfVgNtrNH6P-U57oMD+ptNGFid4bqZqv-Q@mail.gmail.com>
References: <20566.39957.867109.459668@gargle.gargle.HOWL> <CAB=NE6W9O-XvQUJgyfVgNtrNH6P-U57oMD+ptNGFid4bqZqv-Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 17 Sep 2012 18:13:04 -0700
Message-ID: <CAB=NE6VBk6_Fq7NTXXDUK1AVMBXfLRY52n4iLp+njX0e_ms7hA@mail.gmail.com> (sfid-20120918_031333_692352_2361DBA5)
Subject: Re: [PATCH 0/3] Patches for compat 3.6.y
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: linux-wireless@vger.kernel.org, backports@vger.kernel.org,
	Konstantin Ryabitsev <mricon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 17, 2012 at 3:21 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Sun, Sep 16, 2012 at 8:42 PM, Sujith Manoharan <c_manoha@qualcomm.com> wrote:
>> Hi,
>>
>> These patches are for the 3.6.y branch in compat-drivers.
>>
>> Sujith
>>
>> Sujith Manoharan (3):
>>   compat-drivers: Add pending stable patches
>>   compat-drivers: Add new cherry picked patches
>>   compat-drivers: Add linux-next pending patches
>
> Great thanks, applied and pushed!
>
> v3.6-rc6 was pushed out recently as well, and I updated the trees to
> reflect that. Based on that and your patches I've kicked out a new set
> of first tarballs based on v3.6-rc1. These releases did not have any
> pending-stable/ patches as in between v3.6-rc6..next-20120917 and as
> such there are no "-s" releases.
>
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/compat-wireless-3.6-rc6-1.tar.bz2
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/compat-wireless-3.6-rc6-1-n.tar.bz2
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/compat-wireless-3.6-rc6-1-np.tar.bz2
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/compat-wireless-3.6-rc6-1-npc.tar.bz2
>
> Legend
>
> Extra flag meanings:
>
> -s - get and apply pending-stable/ from linux-next.git
> -n - apply the patches linux-next-cherry-picks/ directory
> -p - apply the patches on the linux-next-pending/ directory
> -c - apply the patches on the crap/ directory
>
> When no flags are used it means a vanilla release with 0 delta.
>
> The respective ckmake logs for all releases will be uploaded in about
> 2-3 hours, but before tagging a release I did run ckmake test against
> the -snpc release and everything went fine so I don't suspect issues
> with the rest of the releases.

Respective ckmake logs:

http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/ckmake-3.6-rc6-1.log.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/ckmake-3.6-rc6-1-n.log.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/ckmake-3.6-rc6-1-np.log.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/ckmake-3.6-rc6-1-npc.log.bz2

The results are all OK for all 21 kernels. The compressed logs have
all the details though, a summary for all kernels below.

Trying kernel 3.5.0-030500-generic [OK]
Trying kernel 3.4.4-030404-generic [OK]
Trying kernel 3.3.7-030307-generic [OK]
Trying kernel 3.2.2-030202-generic [OK]
Trying kernel 3.1.10-030110-generic [OK]
Trying kernel 3.0.18-030018-generic [OK]
Trying kernel 2.6.39-02063904-generic [OK]
Trying kernel 2.6.38-02063808-generic [OK]
Trying kernel 2.6.37-02063706-generic [OK]
Trying kernel 2.6.36-02063604-generic [OK]
Trying kernel 2.6.35-02063512-generic [OK]
Trying kernel 2.6.34-02063410-generic [OK]
Trying kernel 2.6.33-02063305-generic [OK]
Trying kernel 2.6.32-02063255-generic [OK]
Trying kernel 2.6.31-02063113-generic [OK]
Trying kernel 2.6.30-02063010-generic [OK]
Trying kernel 2.6.29-02062906-generic [OK]
Trying kernel 2.6.28-02062810-generic [OK]
Trying kernel 2.6.27-020627-generic [OK]
Trying kernel 2.6.26-020626-generic [OK]
Trying kernel 2.6.25-020625-generic [OK]
Trying kernel 2.6.24-020624-generic [OK]

real    26m59.600s
user    141m37.487s
sys     13m34.835s

  Luis
