Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:53658 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3FDKME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:12:04 -0400
Received: by mail-qa0-f52.google.com with SMTP id cr7so264608qab.11
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jun 2013 03:12:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXj8jCgDgvewgm1=QPsUwAKcgWYT-jne0tpnhH_M1GO_w@mail.gmail.com>
References: <CADaB71PpUQar24AN4PtpVwACFVq-=VsbOsqUahPW=eh4wdpjLA@mail.gmail.com>
 <CAGRGNgXj8jCgDgvewgm1=QPsUwAKcgWYT-jne0tpnhH_M1GO_w@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 4 Jun 2013 20:11:42 +1000
Message-ID: <CAGRGNgWG0hR1WH5gteyoH6kKPq8qwvDAXkwRkX5d-uUCai-4OA@mail.gmail.com> (sfid-20130604_121207_911808_0BD01CBD)
Subject: Re: I can't download "Intel(R) PRO/Wireless 2200BG Driver for Linux"
To: Hyun-Su Lim <hyunsu.lim2@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hyunsu,

On Tue, Jun 4, 2013 at 4:56 PM, Hyun-Su Lim <hyunsu.lim2@gmail.com> wrote:
> Dear..
>
> I'm trying to find a driver of Intel(R) PRO/Wireless 2915ABG Network
> Connection to use wireless network in my old laptop with Fedora18.
> Very pleased to find Intel® PRO/Wireless 2200BG Driver for Linux and
> followed your webpage but failed to get download files.
> Because the download page didn't open at
> http://ipw2200.sourceforge.net/firmware.php?i_agree_to_the_license=yes&f=ipw2200-fw-3.1.tgz.
> I hope you can receive this e-mail and hope to get the driver which
> can only solve this network connection problem.

Your kernel should already have a driver for that card, all you need
is the firmware.

Fedora should provide a package containing it. Install that.

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
