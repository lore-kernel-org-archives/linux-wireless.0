Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34483 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab1JSNgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 09:36:52 -0400
Received: by vws1 with SMTP id 1so1203093vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 06:36:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F099D0EF3989304DBA09D2E81781FF0B049E423D@BLR-SJP-MBX4.wipro.com>
References: <F099D0EF3989304DBA09D2E81781FF0B049E41F9@BLR-SJP-MBX4.wipro.com>
	<CAOZOX0XfeX4_JqoXg_Z8VFrfhtR8BrpuoR+rDbE34_dXY4fDgw@mail.gmail.com>
	<F099D0EF3989304DBA09D2E81781FF0B049E423D@BLR-SJP-MBX4.wipro.com>
Date: Wed, 19 Oct 2011 15:36:51 +0200
Message-ID: <CAOZOX0V7iQs4H1ofRtpRgsVEpTqSnHjCOc7juM7gCX47CCGWRA@mail.gmail.com> (sfid-20111019_153655_639650_452F2C56)
Subject: Re: Ralink RT3070: absolute transmit power information
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: raghunathan.kailasanathan@wipro.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 19, 2011 at 3:29 PM,  <raghunathan.kailasanathan@wipro.com> wrote:
>>You are using a driver not supported by this project,
>>so you have to manually change the Ralink driver source code yourself.
>>When you use the rt2x00 drivers, you automatically get the dBm/mW value.
>
> Is there a source tarball of rt2x00 available somewhere ? git ports are blocked by firewall and
> this link does not work :
> http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=summary

You can use compat-wireless tarball,
or the wireless-testing, or linux-2.6 GIT trees.

Ivo
