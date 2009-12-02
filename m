Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:59173 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZLBWum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 17:50:42 -0500
Received: by iwn1 with SMTP id 1so486001iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 14:50:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091128212102.GB28915@redhat.com>
References: <20091128212102.GB28915@redhat.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 2 Dec 2009 14:50:28 -0800
Message-ID: <43e72e890912021450t454dc740r91ea88365779d2c6@mail.gmail.com>
Subject: Re: [internal-ath9k-devel] RHEL5.5 (and Centos 5.5!) wireless updates
	needs broad testing...
To: "John W. Linville" <linville@redhat.com>
Cc: linux-wireless@vger.kernel.org, centos@centos.org,
	ipw3945@lists.sourceforge.net, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 28, 2009 at 1:21 PM, John W. Linville <linville@redhat.com> wrote:
> Greetings,
>
> RHEL5.5 is scheduled for a broad update of wireless LAN bits.
> This includes updates to the cfg80211 and the mac80211 subsystems,
> and the ath5k, iwl3945, iwl4965, iwl5000, rt2400pci, rt2500pci,
> rt2500usb, rt61pci, rt73usb, rtl8180, and rtl8187 drivers, as well as
> the addition of the iwl1000, and iwl6000 drivers and the core of the
> rfkill subsystem.  For good measure, ath9k _may_ be added as well.
> This represents a very large mass of code, and any extra testing is
> most welcome.
>
> Preliminary RHEL5 kernels with these wireless bits are available here:
>
>        http://people.redhat.com/linville/kernels/rhel5/
>
> I have been using them with iwl4965, iwl5000, iwl6000, and ath9k
> hardware here with very satisfactory results.  I would appreciate
> your help testing not only on this hardware but whatever other bits
> of the aforementioned hardware that you may have.
>
> If you have a wireless LAN enabled box running RHEL5 (or CentOS 5 or
> other equivalent) then please give these kernels a try.  When you find
> problems, please open a bug against RHEL5.5 at bugzilla.redhat.com
> and Cc: me on the bug.  Remember, the surest way to avoid a bug in
> RHEL5.5 is to find it before it is released, and the surest way to
> avoid a bug in CentOS is to keep it out of RHEL... :-)
>
> I appreciate your help!


Thanks John, I'm keeping track of ath9k issues with regards to this kernel here:

http://wireless.kernel.org/en/users/Drivers/ath9k/RHEL5

If anyone else finds issues please add a link there.

  Luis
