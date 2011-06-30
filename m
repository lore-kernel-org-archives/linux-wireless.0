Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38848 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1F3XM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 19:12:59 -0400
Received: by bwd5 with SMTP id 5so2206499bwd.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 16:12:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309443595.25768.1.camel@wwguy-ubuntu>
References: <BANLkTim83iarV-J08JAsVtfLR2ziqLs=iQ@mail.gmail.com>
	<20110630095137.GA2666@redhat.com>
	<1309443595.25768.1.camel@wwguy-ubuntu>
Date: Thu, 30 Jun 2011 18:12:58 -0500
Message-ID: <BANLkTinEJ_XZcrV-SwRRJ=r1Heo0-YBhfA@mail.gmail.com> (sfid-20110701_011303_241018_45A7AB2C)
Subject: Re: iwlagn: Problems with Intel Wifi Link 1000 on newer kernels
From: Erik Hardesty <ehardesty@gmail.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forcing iwlwifi-1000-3.ucode results in the same issues. No change in
linux 3.0-rc5.

On Thu, Jun 30, 2011 at 9:19 AM, wwguy <wey-yi.w.guy@intel.com> wrote:
> On Thu, 2011-06-30 at 02:51 -0700, Stanislaw Gruszka wrote:
>> On Fri, Jun 17, 2011 at 01:14:11AM -0500, Erik Hardesty wrote:
>> > Having trouble with iwlagn in kernels newer than 2.6.38.
>> > I've tried 2.6.39 and 3.0rc3 and both give me the same problem.
>> > I have the latest intel firmware installed on the system. Both
>> > iwlwifi-1000-3.ucode
>> > and iwlwifi-1000-5.ucode are in /lib/firmware
>> >
>> > Note: 2.6.38 does not exhibit the same issue and works fine.
>>
>> If there is no other proposition to fix the issue from Intel,
>> perhaps you could bisect the problem.
>
> what if you remove iwlwifi-1000-5.ucode and force to use -3 version of
> uCode; are you still seeing the problem with new kernel?
>
> Thanks
> Wey
>
>
>
