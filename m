Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33421 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932829AbcGGAhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 20:37:00 -0400
Received: by mail-yw0-f196.google.com with SMTP id i12so275064ywa.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2016 17:36:59 -0700 (PDT)
MIME-Version: 1.0
From: Nestor Machno <nestor.machno89@gmail.com>
Date: Thu, 7 Jul 2016 02:36:58 +0200
Message-ID: <CAEOnXSfd6K36cOcUfqy8rBT27TbH9PGy7U4z3TU0N2YWc7GXqA@mail.gmail.com> (sfid-20160707_023704_762673_4D25D642)
Subject: Fwd: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
Amitkumar, can you confirm if this this is a bug or today is fixed?

Vincent, I had also faced similar issue on Surface Pro 2 with
backports from 4.1... So here few question:

* I saw in 1st post that you where working to make work the
wpa_supplicant with mixed configuration for adhoc (wpa-none +
wpa-ibss), but also in recent post that you focus mostly on debugging
wpa-ibss. I suggest to focus your test on one wpa mode and I think
wpa-none better because it's easier..
* Why you are not testing the latest backport from upstream kernel? as
you can know Marvell is focus most to fix open issue on current stable
release, I saw from commit that recently they fix something about WPA
on mixflex, see
https://backports.wiki.kernel.org/index.php/Documentation/compat-drivers/hacking
* Would be good information to know if you tested also on backport
3.x, did you?  I know mwifiex's WPA stack changed a lot from 3.x
kernel.
* To support you more, could you enable debug info and provide full
log of your setup? .config? patch? anything else?
* Can you share us your hacked backport?
* Lat question Vincent, are you working for AIRBUS, ACTIA or THALES ?  :)

Best Regards
Nestor

On Mon, Jun 13, 2016 at 7:42 AM, Vincent CESSON <vincent.cesson@smile.fr> wrote:
> Hi Amitkumar,
>
> Here are the wpa_supplicant logs (with CONFIG_IBSS_RSN=y enabled) from the
> two devices. Beside wpa_supplicant, I manually set IPs 192.168.1.xy with
> command "ifconfig mlan0 192.168.1.xy" and then I try to ping each other,
> without success.
>
> Vincent
